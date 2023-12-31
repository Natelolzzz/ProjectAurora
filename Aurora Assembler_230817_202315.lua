-- Define opcodes for instructions
local opcodes = {
    NOP = 0x00,
    LIA = 0x01,
    ADD = 0x02,
    STC = 0x03,
    LDA = 0x04,
    STA = 0x05,
    LDB = 0x06,
    JZ = 0x07,
    JC = 0x08,
    SZ = 0x09,
    CZ = 0x0A,
    -- Add more opcodes as needed
}

-- Define your assembly code here
local assemblyCode = {
    "LIA 10",
    "ADD B",
    "STC 0",
    "LDA 1",
    "STA B",
    "JZ 2",
    -- Add more assembly instructions here
}

-- Function to assemble the code
local function assemble()
    local machineCode = {}
    local labels = {}

    for _, line in ipairs(assemblyCode) do
        local label, instruction = line:match("(%w+):%s*(.*)")
        if label then
            labels[label] = #machineCode + 1
            line = instruction
        end

        local parts = {}
        for part in line:gmatch("%S+") do
            table.insert(parts, part)
        end

        local opcode = parts[1]
        if opcodes[opcode] then
            local instruction = opcodes[opcode]

            if opcode == "LIA" or opcode == "STC" or opcode == "LDA" then
                local arg = tonumber(parts[2])
                table.insert(machineCode, instruction)
                table.insert(machineCode, arg)
            elseif opcode == "ADD" or opcode == "JZ" or opcode == "JC" or opcode == "SZ" or opcode == "CZ" then
                local reg = parts[2]
                table.insert(machineCode, instruction)
                table.insert(machineCode, reg)
            elseif opcode == "STA" or opcode == "LDB" then
                local reg = parts[2]
                table.insert(machineCode, instruction)
                table.insert(machineCode, reg)
            else
                table.insert(machineCode, instruction)
            end
        else
            print("Invalid opcode: " .. opcode)
            return
        end
    end

    return machineCode, labels
end

local machineCode, labels = assemble()

-- Resolve label addresses
for i, code in ipairs(machineCode) do
    if type(code) == "string" and labels[code] then
        machineCode[i] = labels[code]
    end
end

-- Print the machine code
for _, code in ipairs(machineCode) do
    if type(code) == "number" then
        print(string.format("0x%02X", code))
    else
        print(code)
    end
end
