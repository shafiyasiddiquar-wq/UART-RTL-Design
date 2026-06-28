module tb;

    
    logic clk;
    logic rst;
    logic baud_tick;

    logic tx_start;
    logic [7:0] tx_data;

    logic tx;
    logic tx_busy;

    logic [7:0] rx_data;
    logic rx_valid;

    uart_top dut(
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),

        .tx_start(tx_start),
        .tx_data(tx_data),

        .tx(tx),
        .tx_busy(tx_busy),

        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    initial begin
        baud_tick = 0;
        forever begin
            #95 baud_tick = 1;
            #10 baud_tick = 0;
        end
    end

    
    initial begin

        rst = 1;
        tx_start = 0;
        tx_data = 8'h41;      // ASCII 'A'

        #20;
        rst = 0;

        // Wait before transmitting
        #50;

        // Start transmission
        tx_start = 1;
        #10;
        tx_start = 0;

        // Wait for complete frame
        #2500;

        // Display received byte
        if(rx_valid)
            $display("PASS : Received = %h", rx_data);
        else
            $display("Transmission Complete");

        $finish;

    end

endmodule
