#!/usr/bin/env python
# Plots antenna parameters and milky way for SRT or NSRT telescopes
# NSRT is -85 <= EQ <= 85 and -34 <= DC <= 66 and
# the NSRT minimum elevation is a magenta line
import wx
import wx.lib.agw.gradientbutton as GB
import jlplot
import math
import numpy
import ephem


class MainFrame(wx.Frame):
    def __init__(self, parent, title):
        wx.Frame.__init__(self, parent, title=title, size=(1080, 768))
        self.ppanel = PlotPanel(self)
        self.cpanel = CtrlPanel(self, self.ppanel)
        self.SetBackgroundColour('WHITE')
        vbox = wx.BoxSizer(wx.VERTICAL)
        vbox.Add(self.ppanel, 1, wx.EXPAND)
        vbox.Add((-1, 15))
        vbox.Add(self.cpanel, 0, wx.EXPAND)
        vbox.Add((-1, 15))

        self.SetSizerAndFit(vbox)
        self.Centre()
        self.Show()
        self.interval = 60000
        self.updater = wx.Timer(self, wx.NewId())
        self.Bind(wx.EVT_TIMER, self.cpanel.manage_update)

    def tstart(self):
        self.updater.Start(self.interval, wx.TIMER_CONTINUOUS)

    def tstop(self):
            self.updater.Stop()


    def goodbye(self, evt):
        self.Close()

# end of class MainFrame


class PlotPanel(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent, -1)
        self.ctrl = None
        self.plot = jlplot.PlotCanvas(self, size=(1024,640))
        # this is all once-only stuff for the plot
        #self.plot.SetEnableGrid(True)     # default is False
        self.plot.SetFontSizeAxis(point=18) # default is 10
        self.plot.SetFontSizeTitle(point=20) # default is 15
        self.x_range = 0, 360
        self.y_range = -20.0, 90.0
        self.xLabel = 'AZIMUTH (deg)'
        self.yLabel = 'ELEVATION (deg)'

        # file HADCboundary.dat was created by convert.py, 'boundary' command
        # the path is in 6 parts, separated by hand (JDL)
        self.nparts = 6
        self.fname = 'HADCboundary.dat'
        self.pfile = open(self.fname, 'r')
        self.parts = []
        self.npts = []
        for i in range(self.nparts):
            inpl = self.pfile.readline(8192)
            part = eval(inpl)
            self.parts.append(eval(inpl))
            self.npts.append(len(part))
        self.pfile.close()
        self.hadc_pts = []
        for i in range(self.nparts):
            path = numpy.zeros((self.npts[i], 2), numpy.float32)
            for j in range(self.npts[i]):
                path[j] = (self.parts[i][j][2], self.parts[i][j][3])
            self.hadc_pts.append(path)
        path = [self.hadc_pts[2][-1], self.hadc_pts[3][0]]
        self.hadc_pts.append(path)

        # the horizon.dat files were created by hand by JDL
        self.nhparts = 3
        self.fname = 'srt_horizon.dat'
        self.pfile = open(self.fname, 'r')
        self.hparts = []
        self.hpts = []
        for i in range(self.nhparts):
            inpl = self.pfile.readline(2048)
            part = eval(inpl)
            self.hparts.append(eval(inpl))
            self.hpts.append(len(part))
        self.pfile.close()

        self.fname = 'nsrt_horizon.dat'
        self.pfile = open(self.fname, 'r')
        self.newhparts = []
        self.newhpts = []
        for i in range(self.nhparts):
            inpl = self.pfile.readline(2048)
            part = eval(inpl)
            self.newhparts.append(eval(inpl))
            self.newhpts.append(len(part))
        self.pfile.close()

        self.telescope = ephem.Observer()
        self.telescope.lat = ephem.degrees("42:21:38.67")
        self.telescope.lon = ephem.degrees("-71:05:27.84")
        self.telescope.pressure = 0
        self.telescope.elevation = 30
        self.telescope.date = ephem.now()
        x = str(self.telescope.date).split(' ')
        self.dstr = x[0] + ' at ' + x[1] + ' (UTC)'
        self.real_date = self.telescope.date
        self.tel_dstr = self.dstr

        # For the ISS, get latest TLE data from
        # http://spaceflight.nasa.gov/realdata/sightings/SSapplications/Post/\
        # JavaSSOP/orbit/ISS/SVPOST.html
        # Latest data are at bottom of page; orbit is ~15.52 rev/day.
        line0 = 'ISS'
        line1 = '1 25544U 98067A   12347.55749990  .00016717  00000-0  10270-3 0  9147'
        line2 = '2 25544  51.6459 315.4423 0016458  31.8063 328.4079 15.52127783  5727'
        self.iss = ephem.readtle(line0, line1, line2)
        # COBE TLE data (12/2/2012) were obtained from
        # http://www.infosatellites.com/cobe-satellite-information-norad-20322.html
        line0 = 'COBE'
        line1 = '1 20322U 89089A   12336.54647742 -.00000269  00000-0 -14074-3 0  9108'
        line2 = '2 20322 099.0019 342.7368 0008241 201.9943 158.0866 14.04523050180507'
        self.cobe = ephem.readtle(line0, line1, line2)

        self.crab = ephem.readdb('Crab Nebula,f|R,5:34:31.9,22:0:52,8.4,2000,360')
        self.cass = ephem.readdb('Alpha Cassiopeiae,f|D|K0,0:40:30.44|50.37,56:32:14.39|-32.2,2.25,2000')
        self.andr = ephem.readdb('Andromeda,f|D|B9,0:8:23.26|135.67,29:5:25.55|-163,2.06,2000')
        self.orio = ephem.readdb('Orion Nebula,f|N|EN,5:35:17.1,-5:23:25,4,2000,3900')
        #self.betel = ephem.readdb('Betelgeuse,f|D|M1,5:55:10.31|27.37,7:24:25.43|10.9,0.57,2000')

        self.GetLocations()
        self.RefreshThePlot(True)

    def time_update(self, doff=0.0, hoff=0.0):
        #print("doff=%4.2f, hoff=%4.2f" % (doff, hoff))
        self.real_date = ephem.now()
        self.telescope.date = ephem.Date(self.real_date+doff+hoff*ephem.hour)
        x = str(self.real_date).split(' ')
        self.dstr = x[0] + ' at ' + x[1] + ' (UTC)'
        x = str(self.telescope.date).split(' ')
        self.tel_dstr = x[0] + ' at ' + x[1] + ' (UTC)'
        #print(self.dstr+' -> '+self.tel_dstr)
        self.GetLocations()

    def GetLocations(self):
        self.sun = ephem.Sun(self.telescope)
        self.sun_az = self.tup2deg(self.angle2tuple(self.sun.az))
        self.sun_el = self.tup2deg(self.angle2tuple(self.sun.alt))
        self.moon = ephem.Moon(self.telescope)
        self.moon_az = self.tup2deg(self.angle2tuple(self.moon.az))
        self.moon_el = self.tup2deg(self.angle2tuple(self.moon.alt))
        self.mway = []
        self.markers = []
        self.MilkyWay()
        if self.ctrl != None:
            if self.ctrl.ISS_cb.IsChecked():
                self.iss.compute(self.telescope)
                self.iss_az = self.angle2deg(self.iss.az)
                self.iss_el = self.angle2deg(self.iss.alt)
            else:
                self.iss_el = -100
            if self.ctrl.COBE_cb.IsChecked():
                self.cobe.compute(self.telescope)
                self.cobe_az = self.angle2deg(self.cobe.az)
                self.cobe_el = self.angle2deg(self.cobe.alt)
            else:
                self.cobe_el = -100
            if self.ctrl.Mars_cb.IsChecked():
                self.mars = ephem.Mars(self.telescope)
                self.mars_az = self.tup2deg(self.angle2tuple(self.mars.az))
                self.mars_el = self.tup2deg(self.angle2tuple(self.mars.alt))
            else:
                self.mars_el = -100
            if self.ctrl.Venus_cb.IsChecked():
                self.venus = ephem.Venus(self.telescope)
                self.venus_az = self.tup2deg(self.angle2tuple(self.venus.az))
                self.venus_el = self.tup2deg(self.angle2tuple(self.venus.alt))
            else:
                self.venus_el = -100
            if self.ctrl.Jupiter_cb.IsChecked():
                self.jup = ephem.Jupiter(self.telescope)
                self.jup_az = self.tup2deg(self.angle2tuple(self.jup.az))
                self.jup_el = self.tup2deg(self.angle2tuple(self.jup.alt))
            else:
                self.jup_el = -100
            if self.ctrl.Saturn_cb.IsChecked():
                self.sat = ephem.Saturn(self.telescope)
                self.sat_az = self.tup2deg(self.angle2tuple(self.sat.az))
                self.sat_el = self.tup2deg(self.angle2tuple(self.sat.alt))
            else:
                self.sat_el = -100
            if self.ctrl.Andr_cb.IsChecked():
                self.andr.compute(self.telescope)
                self.andr_az = self.tup2deg(self.angle2tuple(self.andr.az))
                self.andr_el = self.tup2deg(self.angle2tuple(self.andr.alt))
            else:
                self.andr_el = -100
            if self.ctrl.Cass_cb.IsChecked():
                self.cass.compute(self.telescope)
                self.cass_az = self.tup2deg(self.angle2tuple(self.cass.az))
                self.cass_el = self.tup2deg(self.angle2tuple(self.cass.alt))
            else:
                self.cass_el = -100
            if self.ctrl.Crab_cb.IsChecked():
                self.crab.compute(self.telescope)
                self.crab_az = self.tup2deg(self.angle2tuple(self.crab.az))
                self.crab_el = self.tup2deg(self.angle2tuple(self.crab.alt))
            else:
                self.crab_el = -100
            if self.ctrl.Orio_cb.IsChecked():
                self.orio.compute(self.telescope)
                self.orio_az = self.tup2deg(self.angle2tuple(self.orio.az))
                self.orio_el = self.tup2deg(self.angle2tuple(self.orio.alt))
            else:
                self.orio_el = -100

    def MilkyWay(self):
        spots = [(0,0),(10,0),(20,0),(30,0),(40,0),(50,0),(60,0),
            (70,0),(80,0),(90,0),(100,0),(110,0),(120,0),
            (130,0),(140,0),(150,0),(160,0),(170,0),(180,0),
            (190,0),(200,0),(210,0),(220,0),(230,0),(240,0),
            (250,0),(260,0),(270,0),(280,0),(290,0),(300,0),
            (310,0),(320,0),(330,0),(340,0),(350,0)]
        vis = 0
        for spot in spots:
            eqpt = ephem.Equatorial(ephem.Galactic(str(spot[0]), str(spot[1])))
            # line is in the format of an entry in the Xephem database;
            # see section 7.1.2 of the Xephem Reference Manual at
            # http://www.clearskyinstitute.com/xephem/help/xephem.html
            line = 'mwaypoint,f,' + str(eqpt.ra) + ',' + str(eqpt.dec) + ',1'
            target = ephem.readdb(line)
            target.compute(self.telescope)
            az_deg = self.angle2deg(target.az)
            el_deg = self.angle2deg(target.alt)
            if el_deg > -20:
                self.mway.append( (az_deg, el_deg) )
                self.markers.append( (az_deg+1.5, el_deg+1.5, str(spot[0])) )
                vis = vis + 1
        if not vis > 0:
            print(str(vis)+" visible milky way points")

    def angle2deg(self, angle):
        x = str(angle).split(':')
        fp = float(x[1])/60.0 + float(x[2])/3600.0
        deg = float(x[0])
        if deg < 0.0:
            return deg - fp
        else:
            return deg + fp

    def angle2tuple(self, angle):
        x = str(angle).split(':')
        return (int(x[0]), int(x[1]), int(float(x[2])))

    def deg2tup(self, arg):
        tmp1 = math.modf(arg)
        tmp2 = math.modf(60.0*tmp1[0])
        tmp3 = math.modf(60.0*tmp2[0])
        if arg < 0:
            tup = (int(tmp1[1]), -int(tmp2[1]), -int(tmp3[1]))
        else:
            tup = (int(tmp1[1]), int(tmp2[1]), int(tmp3[1]))
        return(tup)

    def tup2deg(self, arg):
        deg = float(arg[0])
        dec = float(arg[1])/60.0 + float(arg[2])/3600.0
        if deg < 0.0:
            deg -= dec
        else:
            deg += dec
        return deg

    def RefreshThePlot(self, srt):
        lines = [jlplot.PolyLine([(0.0, 0.0), (360.0, 0.0)],colour='GREEN',
                 width=4),]

        if srt:
            titl = 'SRT AZEL Range and Targets for ' + self.tel_dstr
            lines.append(jlplot.PolyLine(self.hparts[0], colour='BLUE', width=1))
            lines.append(jlplot.PolyLine(self.hparts[1], colour='RED', width=1))
            lines.append(jlplot.PolyLine(self.hparts[2], colour='BLUE', width=1))
        else:
            titl = 'NSRT AZEL Range and Targets for ' + self.tel_dstr
            for path in self.hadc_pts:
                lines.append(jlplot.PolyLine(path, colour='MAGENTA', width=2))
            lines.append(jlplot.PolyLine(self.newhparts[0], colour='BLUE', width=1, style=wx.SHORT_DASH))
            lines.append(jlplot.PolyLine(self.newhparts[1], colour='RED', width=1, style=wx.SHORT_DASH))
            lines.append(jlplot.PolyLine(self.newhparts[2], colour='BLUE', width=1, style=wx.SHORT_DASH))

        #lines.append(jlplot.PolyLine(self.mway, colour='SLATE BLUE', width=4))
        if len(self.markers) > 0:
            lines.append(jlplot.PolyMarker(self.mway, colour='BLACK', marker='circle', size=1))
            lines.append(jlplot.PolyMarker(self.markers, colour='BLACK', marker='text', size=11))

        if self.sun_el > -20:
            lines.append(jlplot.PolyMarker((self.sun_az, self.sun_el), colour='#F0F000', marker='circle', size=3))
        else:
            list = []
            str = "Sun is at "+'{:3.1f}'.format(self.sun_az)+", "+'{:3.1f}'.format(self.sun_el)
            list.append((10, -10, str))
            lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=10))

        if self.moon_el > -20:
            lines.append(jlplot.PolyMarker((self.moon_az, self.moon_el), colour='MEDIUM GOLDENROD', marker='circle', size=3))
        else:
            list = []
            str = "Moon is at "+'{:3.1f}'.format(self.moon_az)+", "+'{:3.1f}'.format(self.moon_el)
            list.append((10, -14, str))
            lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=10))

        if self.ctrl != None and self.mars_el > -100:
            #print("Mars is at "+'{:3.1f}'.format(self.mars_az)+", "+'{:3.1f}'.format(self.mars_el))
            if self.mars_el > -20:
                lines.append(jlplot.PolyMarker((self.mars_az, self.mars_el), colour=(250,64,64), marker='circle', size=1))
                list = []
                list.append((self.mars_az+1.5, self.mars_el+1.5, 'Mars'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.venus_el > -100:
            #print("Venus is at "+'{:3.1f}'.format(self.venus_az)+", "+'{:3.1f}'.format(self.venus_el))
            if self.venus_el > -20:
                lines.append(jlplot.PolyMarker((self.venus_az, self.venus_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.venus_az+1.5, self.venus_el+1.5, 'Venus'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.jup_el > -100:
            #print("Jupiter is at "+'{:3.1f}'.format(self.jup_az)+", "+'{:3.1f}'.format(self.jup_el))
            if self.jup_el > -20:
                lines.append(jlplot.PolyMarker((self.jup_az, self.jup_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.jup_az+1.5, self.jup_el+1.5, 'Jupiter'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.sat_el > -100:
            #print("Saturn is at "+'{:3.1f}'.format(self.sat_az)+", "+'{:3.1f}'.format(self.sat_el))
            if self.sat_el > -20:
                lines.append(jlplot.PolyMarker((self.sat_az, self.sat_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.sat_az+1.5, self.sat_el+1.5, 'Saturn'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.andr_el > -100:
            #print("Andromeda is at "+'{:3.1f}'.format(self.andr_az)+", "+'{:3.1f}'.format(self.andr_el))
            if self.andr_el > -20:
                lines.append(jlplot.PolyMarker((self.andr_az, self.andr_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.andr_az+1.5, self.andr_el+1.5, 'Androm'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.cass_el > -100:
            #print("Cassiopaea is at "+'{:3.1f}'.format(self.cass_az)+", "+'{:3.1f}'.format(self.cass_el))
            if self.cass_el > -20:
                lines.append(jlplot.PolyMarker((self.cass_az, self.cass_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.cass_az+1.5, self.cass_el+1.5, 'Cassi'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.crab_el > -100:
            #print("Crab Nebula is at "+'{:3.1f}'.format(self.crab_az)+", "+'{:3.1f}'.format(self.crab_el))
            if self.crab_el > -20:
                lines.append(jlplot.PolyMarker((self.crab_az, self.crab_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.crab_az+1.5, self.crab_el+1.5, 'Crab'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))
        if self.ctrl != None and self.orio_el > -100:
            #print("Orion Nebula is at "+'{:3.1f}'.format(self.orio_az)+", "+'{:3.1f}'.format(self.orio_el))
            if self.orio_el > -20:
                lines.append(jlplot.PolyMarker((self.orio_az, self.orio_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.orio_az+1.5, self.orio_el+1.5, 'Orion'))
                lines.append(jlplot.PolyMarker(list, colour='BLACK', marker='text', size=11))

        if self.ctrl != None and self.iss_el > -100:
            #print("The ISS is at %4.2f, %4.2f" % (self.iss_az, self.iss_el))
            if self.iss_el > -20:
                lines.append(jlplot.PolyMarker((self.iss_az, self.iss_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.iss_az+1.5, self.iss_el+1.6, 'ISS'))
                lines.append(jlplot.PolyMarker(list, colour='SLATE BLUE', marker='text', size=11))
            else:
                list = []
                str = "ISS is at %4.2f, %4.2f" % (self.iss_az, self.iss_el)
                list.append((10, -6, str))
                lines.append(jlplot.PolyMarker(list, colour='SLATE BLUE', marker='text', size=10))
        if self.ctrl != None and self.cobe_el > -100:
            #print("The COBE is at %4.2f, %4.2f" % (self.cobe_az, self.cobe_el))
            if self.cobe_el > -20:
                lines.append(jlplot.PolyMarker((self.cobe_az, self.cobe_el), colour='SLATE BLUE', marker='circle', size=1))
                list = []
                list.append((self.cobe_az+1.5, self.cobe_el+1.6, 'COBE'))
                lines.append(jlplot.PolyMarker(list, colour='SLATE BLUE', marker='text', size=11))
            else:
                list = []
                str = "COBE is at %4.2f, %4.2f" % (self.cobe_az, self.cobe_el)
                list.append((80, -6, str))
                lines.append(jlplot.PolyMarker(list, colour='SLATE BLUE', marker='text', size=10))


        graphics = jlplot.PlotGraphics(lines,
            title=titl, xLabel=self.xLabel, yLabel=self.yLabel)
        self.plot.Draw(graphics, xAxis=self.x_range, yAxis=self.y_range,
            ystep=10.0,
            xstep=20.0)

# end of class PlotPanel


class CtrlPanel(wx.Panel):
    def __init__(self, parent, plotter):
        self.mf = parent
        self.plotter = plotter
        plotter.ctrl = self
        wx.Panel.__init__(self, parent, -1)
        vbox1 = wx.BoxSizer(wx.VERTICAL)
        hbox1 = wx.BoxSizer(wx.HORIZONTAL)
        st1 = wx.StaticText(self, label='Date/Time Offset: ')
        self.tc1 = wx.TextCtrl(self, value='0.0', size=(48, -1), style=wx.TE_PROCESS_ENTER)
        self.tc1.SetValue('0.0')
        self.tc1.Bind(wx.EVT_TEXT_ENTER, self.manage_update)
        st2 = wx.StaticText(self, label=' days and ')
        self.tc2 = wx.TextCtrl(self, value='0.0', size=(48, -1), style=wx.TE_PROCESS_ENTER)
        self.tc2.SetValue('0.0')
        self.tc2.Bind(wx.EVT_TEXT_ENTER, self.manage_update)
        self.st3 = wx.StaticText(self, label=' hours from '+self.plotter.dstr)
        hbox1.Add((12,-1))
        hbox1.Add(st1)
        hbox1.Add(self.tc1, proportion=0)
        hbox1.Add(st2)
        hbox1.Add(self.tc2, proportion=0)
        hbox1.Add(self.st3, flag=wx.RIGHT, border=8)
        self.antennas = list()
        srt_button = wx.RadioButton(self, -1, 'SRT')
        srt_button.Bind(wx.EVT_RADIOBUTTON, self.antenna_change)
        self.antennas.append(srt_button)
        nsrt_button = wx.RadioButton(self, -1, 'NSRT')
        nsrt_button.Bind(wx.EVT_RADIOBUTTON, self.antenna_change)
        self.antennas.append(nsrt_button)
        hbox1.Add((12,-1))
        hbox1.Add(srt_button)
        #hbox1.Add((6,-1))
        hbox1.Add(nsrt_button)
        self.timer_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Update Every ')
        self.timer_cb.Bind(wx.EVT_CHECKBOX, self.manage_timer)
        hbox1.Add((12,-1))
        hbox1.Add(self.timer_cb)
        opts = []
        opts.append(' 1 min')
        opts.append(' 2 min')
        opts.append(' 5 min')
        opts.append('10 min')
        opts.append('60 min')
        self.timer_interval = wx.Choice(self, choices=opts)
        self.timer_interval.Bind(wx.EVT_CHOICE, self.set_interval)
        self.timer_interval.SetSelection(0)
        self.ti_choice = 0
        hbox1.Add(self.timer_interval)
        hbox1.AddStretchSpacer()
        hbox2 = wx.BoxSizer(wx.HORIZONTAL)
        q_button = GB.GradientButton(self, label='Quit', size=(70, 30))
        q_button.SetForegroundColour(wx.RED)
        #q_button.SetPulseOnFocus(True)
        q_button.Bind(wx.EVT_BUTTON, self.mf.goodbye)
        ud_button = GB.GradientButton(self, label='Update Now', size=(84, 30))
        ud_button.SetTopStartColour(wx.GREEN)
        ud_button.SetTopEndColour(wx.GREEN)
        ud_button.SetBottomStartColour(wx.GREEN)
        ud_button.SetBottomEndColour(wx.GREEN)
        ud_button.SetForegroundColour(wx.BLACK)
        ud_button.Bind(wx.EVT_BUTTON, self.manage_update)
        st4 = wx.StaticText(self, label='Show: ')
        self.COBE_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='COBE')
        self.ISS_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='ISS')
        self.Mars_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Mars')
        self.Venus_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Venus')
        self.Jupiter_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Jupiter')
        self.Saturn_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Saturn')
        self.Andr_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Andromeda')
        self.Cass_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Cassi')
        self.Crab_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Crab')
        self.Orio_cb = wx.CheckBox(self, style=wx.CHK_2STATE, label='Orion')
        hbox2.Add((24, -1))
        hbox2.Add(q_button)
        hbox2.Add((12, -1))
        hbox2.Add(st4)
        hbox2.Add(self.ISS_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.COBE_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Mars_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Venus_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Jupiter_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Saturn_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Andr_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Cass_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Crab_cb)
        hbox2.Add((12, -1))
        hbox2.Add(self.Orio_cb)
        hbox2.AddStretchSpacer()
        hbox2.Add(ud_button, flag=wx.ALIGN_RIGHT|wx.RIGHT, border=20)
        vbox1.Add(hbox1, flag=wx.EXPAND|wx.RIGHT|wx.LEFT)
        vbox1.Add((-1, 10))
        vbox1.Add(hbox2, flag=wx.EXPAND|wx.RIGHT|wx.LEFT)

        self.antennas[0].SetValue(True)
        self.timer_cb.SetValue(False)

        self.SetSizer(vbox1)

    def antenna_change(self, evt):
        self.plotter.RefreshThePlot(self.antennas[0].GetValue())

    def manage_update(self, evt):
        d_off = float(self.tc1.GetValue())
        h_off = float(self.tc2.GetValue())
        #print("d_off=%4.2f, h_off=%4.2f" % (d_off, h_off))
        self.plotter.time_update(d_off, h_off)
        self.plotter.RefreshThePlot(self.antennas[0].GetValue())
        self.st3.SetLabel(' hours from ' + self.plotter.dstr)
        if self.timer_cb.IsChecked():
            self.mf.tstart()

    def manage_timer(self, evt):
        if evt.IsChecked():
            self.mf.tstart()
        else:
            self.mf.tstop()

    def set_interval(self, evt):
        c = self.timer_interval.GetSelection()
        # returns index of selected choice
        if c == self.ti_choice:
            return
        if c == 0:
            self.mf.interval = 60000
        elif c == 1:
            self.mf.interval = 120000
        elif c == 2:
            self.mf.interval = 300000
        elif c == 3:
            self.mf.interval = 600000
        elif c == 4:
            self.mf.interval = 3600000
        else:
            self.mf.interval = 60000
        if self.timer_cb.IsChecked():
            self.mf.tstart()
        self.ti_choice = c

# end of class CtrlPanel


if __name__ == '__main__':
    app = wx.App(0)
    MainFrame(None, title='AZEL Plot of Junior Lab Radio Telescope Antenna Parameters')
    app.MainLoop()

