
class uart_stress_sequence extends uvm_sequence #(uart_item);
    `uvm_object_utils(uart_stress_sequence)

    function new(string name="uart_stress_sequence");
        super.new(name);
    endfunction

    virtual task body();
        uart_item req;
        int rand_prob; // Helper variable for weighting

        // TEST 1: Edge Case
        // Send 0x00 in a burst
        repeat(5) begin
            req = uart_item::type_id::create("req");
            start_item(req);
            
            req.data = 8'h00;
            req.delay = 0; // Burst
            
            finish_item(req);
        end

        // TEST 2: Edge Case
        // Send 0xFF with delays
        repeat(5) begin
            req = uart_item::type_id::create("req");
            start_item(req);
            
            req.data = 8'hFF;
            req.delay = $urandom_range(1, 20); // Let delay be random
            
            finish_item(req);
        end

        // TEST 3: Random Stress
        // constraints (70% burst, 10% hold)
        repeat(50) begin
            req = uart_item::type_id::create("req");
            start_item(req);
            
            // Manual Data Randomization
            req.data = $urandom_range(0, 255);

            // Manual Weighted Distribution for Delay
            rand_prob = $urandom_range(0, 99);
            
            if (rand_prob < 70) begin
                req.delay = 0;                      // 0-69 (70% Burst)
            end else if (rand_prob < 90) begin
                req.delay = $urandom_range(1, 20);  // 70-89 (20% Small Delay)
            end else begin
                req.delay = 1000;                   // 90-99 (10% Hold)
            end

            finish_item(req);
        end

    endtask
endclass