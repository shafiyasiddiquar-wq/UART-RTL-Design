DESIGN-

module uart_rx #(
    parameter DATA_BITS = 8
)(
    input  logic                 clk,
    input  logic                 rst,
    input  logic                 baud_tick,
    input  logic                 rx,

    output logic [DATA_BITS-1:0] rx_data,
    output logic                 rx_valid
);

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;

    logic [DATA_BITS-1:0] shift_reg;
    logic [2:0] bit_count;

    always_ff @(posedge clk or posedge rst) begin

        if(rst) begin
            state     <= IDLE;
            shift_reg <= 0;
            rx_data   <= 0;
            bit_count <= 0;
            rx_valid  <= 0;
        end
        else begin

            // Default
            rx_valid <= 0;

            case(state)

                
                IDLE: begin

                    bit_count <= 0;

                    if(rx == 0)
                        state <= START;

                end

                
                START: begin

                    if(baud_tick)
                        state <= DATA;

                end

                
                DATA: begin

                    if(baud_tick) begin

                        shift_reg <= {rx, shift_reg[7:1]};

                        if(bit_count == 3'd7)
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1;

                    end

                end

                
                STOP: begin

                    if(baud_tick) begin

                        rx_data  <= shift_reg;
                        rx_valid <= 1;

                        state <= IDLE;

                    end

                end

            endcase

        end

    end

endmodule

TESTBENCH-

module tb;

logic clk;
logic rst;
logic baud_tick;
logic rx;

logic [7:0] rx_data;
logic rx_valid;

uart_rx dut(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .rx_data(rx_data),
    .rx_valid(rx_valid)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
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
    rx  = 1;

    #20;
    rst = 0;

    // Start bit
    #70;
    rx = 0;

   
    #105 rx = 1;
    #105 rx = 0;
    #105 rx = 0;
    #105 rx = 0;
    #105 rx = 0;
    #105 rx = 0;
    #105 rx = 1;
    #105 rx = 0;

    
    #105 rx = 1;

    #300;

    $finish;

end

endmodule
