function bananas = smooth3(data,span)

bananas = smooth(smooth(smooth(data,span),span),span);

end
