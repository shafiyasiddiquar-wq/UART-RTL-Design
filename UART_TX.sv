DESIGN-

module uart_tx #(
    parameter DATA_BITS = 8
)(
    input  logic                 clk,
    input  logic                 rst,
    input  logic                 baud_tick,
    input  logic                 tx_start,
    input  logic [DATA_BITS-1:0] tx_data,

    output logic                 tx,
    output logic                 tx_busy
);

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;

    logic [7:0] shift_reg;
    logic [2:0] bit_count;

    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end

        else begin

            case (state)

                
                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start) begin
                        shift_reg <= tx_data;
                        bit_count <= 3'd0;
                        tx_busy   <= 1'b1;
                        state     <= START;
                    end
                end

                
                START: begin
                    tx <= 1'b0;

                    if (baud_tick)
                        state <= DATA;
                end

                
                DATA: begin

                    if (baud_tick) begin

                        tx <= shift_reg[0];
                        shift_reg <= {1'b0, shift_reg[7:1]};

                        if (bit_count == 3'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1'b1;
                        end

                    end

                end

                
                STOP: begin

                    tx <= 1'b1;

                    if (baud_tick) begin
                        tx_busy <= 1'b0;
                        state   <= IDLE;
                    end

                end

                default: begin
                    state <= IDLE;
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
logic tx_start;
logic [7:0] tx_data;

logic tx;
logic tx_busy;

uart_tx dut(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
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
    tx_start = 0;
    tx_data = 8'h41;   // ASCII 'A'

    #20;
    rst = 0;

    #40;
    tx_start = 1;

    #10;
    tx_start = 0;

    #1500;

    $finish;

end

endmodule
