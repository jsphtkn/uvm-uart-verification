class uart_item extends uvm_sequence_item;
    rand bit [7:0] data;
    // bit      tx_drive; // We left these to the driver to handle internally

    // Timing error constraints control knobs
    rand int delay;

    // Timing stress constraint
    constraint c_stress_timing {
        // Weighted Distribution:
        // 70% of the time: 0 Delay (Burst Mode - Back to Back)
        // 20% of the time: Small Delay (Normal behavior)
        // 10% of the time: Huge Delay (Long Hold - Test receiver idle stability)
        delay dist { 
            0       := 70, 
            [1:20]  := 20, 
            1000    := 10 
        };
    }

    `uvm_object_utils_begin(uart_item)
        `uvm_field_int(data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_int(delay, UVM_DEFAULT | UVM_DEC)
    `uvm_object_utils_end   

    // Constructor
    function new(input string name = "uart_item");
        super.new(name);
    endfunction : new
endclass