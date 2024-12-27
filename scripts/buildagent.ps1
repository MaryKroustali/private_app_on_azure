# Edit below commands based on guidelines in 
# Github Repository Settings > Actions > Runners > New self-hosted runner (Windows)

# Create a folder under the drive root
mkdir actions-runner; cd actions-runner
# Download the latest runner package
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-win-x64-2.321.0.zip -OutFile actions-runner-win-x64-2.321.0.zip
# Optional: Validate the hash
if((Get-FileHash -Path actions-runner-win-x64-2.321.0.zip -Algorithm SHA256).Hash.ToUpper() -ne '88d754da46f4053aec9007d172020c1b75ab2e2049c08aef759b643316580bbc'.ToUpper()){ throw 'Computed checksum did not match' }
# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.321.0.zip", "$PWD")
# Create the runner and start the configuration experience
./config.cmd --url https://github.com/MaryKroustali/private_app_on_azure --token AQ6ZEQCHOTULVCHXQZEV4LTHN3NT6
# Run it!
./run.cmd