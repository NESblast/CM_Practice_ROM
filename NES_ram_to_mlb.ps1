# Chat Fuckin GPT wrote this thing
# Well, the tough parts anyway 
# I fixed the logic, but still...
# Our days are numbered man

# - Me  4/2023


# Specify the file path here
$file_path = $args[0]
$file_name = $args[1]
$output_path = $file_path+$file_name+"_ROM.mlb"
$sym_path = $file_path+"src\"+$file_name+"_RAM.asm"

# Open the input file and read its contents
$content = Get-Content $sym_path

# Open the output file for writing
$output_file = [System.IO.File]::CreateText($output_path)

$mesen_prefix = "NesInternalRam:"

# Loop through each line in the file and update the value
foreach ($line in $content) {
    if ($line -match "^([^=]+)=([^;]*);?") {

        # Extract the content before "=" and after ";"
        $content_before_eq = $matches[1].Trim()
        $content_before_semicolon = $matches[2].Trim()
        $content_before_semicolon = $content_before_semicolon -replace "\$", ""
        $content_after_semicolon = $line -replace "^.*;", ""

         # Set $content_after_semicolon to empty if no semicolon detected
        if ($content_after_semicolon -eq $line) {
            $content_after_semicolon = ""
        }
        else {
            $content_after_semicolon = ":"+$content_after_semicolon
        }

        # Convert cart ram values to $0000-$1FFFF
        if($mesen_prefix -eq "NesSaveRam:"){
            $cartram_converted_value = [convert]::ToInt32($content_before_semicolon, 16) % 8192
            $content_before_semicolon = [convert]::ToString($cartram_converted_value, 16).PadLeft(4, '0')
        }
        
        $output_file.WriteLine($mesen_prefix+$content_before_semicolon.PadLeft(4, '0')+":"+$content_before_eq+$content_after_semicolon)

    }
    elseif ($line -match "RAM_CART") {
        # Detect "RAM_CART" in the line and adjust $mesen_prefix
        $mesen_prefix = "NesSaveRam:"
    }

}

$output_file.Close()