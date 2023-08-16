# Chat Fuckin GPT wrote this thing
# Well, the tough parts anyway 
# I fixed the logic, but still...
# Our days are numbered man

# - Me  4/2023


# Specify the file path here
$file_path = $args[0]
$output_path = "$file_path"+"_ROM.mlb"
$sym_path = "$file_path.sym"

# Open the input file and read its contents
$content = Get-Content $sym_path

# Open the output file for writing
$output_file = [System.IO.File]::CreateText($output_path)

# Loop through each line in the file and update the value
foreach ($line in $content) {
   if ($line -match "^([0-9a-fA-F]{2}):[0-9a-fA-F]+") {
        # Extract the hexadecimal prefix and value
        $hex_prefix = $matches[1]
        $decimal_value2 = [convert]::ToInt32($hex_prefix, 16) * 8192

        # Extract the hexadecimal value
        $hex_value = $line -replace "^.*:([0-9a-fA-F]+).*", '$1'

        # Convert the hexadecimal value to an integer and subtract 32768 (i.e., 0x8000)
        $original_value = [convert]::ToInt32($hex_value, 16)
        $decimal_value = $original_value % 8192 + $decimal_value2
        $new_hex_value = [convert]::ToString($decimal_value, 16).PadLeft(4, '0')

        # Define the correct .MLB prefix
        $mesenLabel = "NesPrgRom:"
        if($original_value -lt 8192) { $mesenLabel = "NesMemory:" }
        elseif($original_value -lt 32768) { $mesenLabel = "NesSaveRam:" }

        # Convert the line format to .MLB format
        $new_line = $line -replace $hex_value, $new_hex_value
        $new_line = $new_line -replace "^.*:", $mesenLabel
        $new_line = $new_line -replace " ", ":"

        # Output the decimal value to the console
        $output_file.WriteLine($new_line)
    }
}

$output_file.Close()