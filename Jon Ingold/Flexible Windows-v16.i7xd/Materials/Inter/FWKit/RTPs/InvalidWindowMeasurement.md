# Invalid window measurement

When Glk windows are created using the proportional sized or constrained split methods, their measurement must be between 0 and 100 (as it is a percentage).

Fixed sized windows cannot have a negative measurement, likewise the minimum and maximum size of a constrained window cannot be negative.