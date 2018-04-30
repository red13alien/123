r <- ( RandomInt( 55, 155 )).tostring();
g <- ( RandomInt( 155, 200 )).tostring();
b <- ( RandomInt( 55, 155 )).tostring();
colour <- r + " " + g + " " + b;
EntFireByHandle(self, "Color", colour, 0, self, self);