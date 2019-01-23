# Go-PYNQ
Run final.jpynb after connecting the necessary peripherals for SPI, UART, I2C Communication. 
The fiile final.jpynb requires additional hardware other than PYNQ board.
SPI protocol is being used to aquire data from the bms module.
UART is being used to communicate the aquired data to simulink model.
The AFE module only supports I2C protocol hence the swiching is being controlled by i2c
