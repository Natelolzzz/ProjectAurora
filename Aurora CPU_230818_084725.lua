-- Define constants for memory sizes and regions
local MEMORY_SIZE = 16384  -- Combined size of RAM and ROM
local ROM_START = 1
local RAM_START = 8192

-- Create a memory array for RAM and ROM
local memory = {}

-- Initialize registers
local registers = {
    A = 0,
    B = 0,
    C = 0,
    PC = ROM_START,  -- Start execution from ROM
}

-- Initialize stack pointer and flags
local stackPointer = 0
local flags = {
    zero = false,
    carry = false,
}

-- Initialize interrupt flag and interrupt vector
local interruptFlag = false
local interruptVector = 0x100

-- Load ROM contents (for demonstration, fill with sample instructions)
local romContents = {}  -- Empty ROM
for i = 1, MEMORY_SIZE do
    memory[i] = 0
end

-- Initialize display output buffer
local displayOutput = ""

-- Emulation loop
local lastExecutionTime = os.clock()  -- Initialize the last execution time
local frameTime = 1 / 60  -- Desired time for each frame at 60Hz

while true do
    local currentTime = os.clock()
    local elapsedTime = currentTime - lastExecutionTime

    -- Accumulate display output
    displayOutput = displayOutput .. "PC: " .. registers.PC .. ", A: " .. registers.A .. ", B: " .. registers.B .. ", C: " .. registers.C .. "\n"

    if elapsedTime >= frameTime then
        lastExecutionTime = currentTime

        local instruction = memory[registers.PC]

        -- Check for interrupts
        if interruptFlag then
            memory[RAM_START + stackPointer] = registers.PC + 1
            stackPointer = stackPointer - 1
            registers.PC = interruptVector
            interruptFlag = false
        end

        -- Decode and execute instruction
        if instruction == 0x00 then
            -- No-Operation (NOP)
            registers.PC = registers.PC + 1
        elseif instruction == 0x01 then
            -- Load immediate value into register A
            registers.A = memory[registers.PC + 1]
            registers.PC = registers.PC + 2
        elseif instruction == 0x02 then
            -- Add register A and register B, store result in register C
            local sum = registers.A + registers.B
            if sum > 255 then
                flags.carry = true
                sum = sum % 256
            else
                flags.carry = false
            end
            registers.C = sum
            registers.PC = registers.PC + 1
        -- ... (other instructions)
        else
            -- Invalid instruction
            displayOutput = displayOutput .. "Invalid instruction\n"
            break
        end

        -- Clear display output buffer
        displayOutput = ""
    end
end
