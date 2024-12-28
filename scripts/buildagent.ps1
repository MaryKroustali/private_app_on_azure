# Edit below commands based on guidelines in 
# Github Repository Settings > Actions > Runners > New self-hosted runner (Windows)
# Additionally to run as a service follow instructions on
# https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service

# Create a folder under admin directory
cd C:/
mkdir actions-runner; cd actions-runner
# Download the latest runner package
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-win-x64-2.321.0.zip -OutFile actions-runner-win-x64-2.321.0.zip
# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.321.0.zip", "$PWD")
# Create the runner and start running as a service
./config.cmd --runasservice --unattended --url https://github.com/MaryKroustali/private_app_on_azure --token AQ6ZEQHFMACQJNNSFGC23YLHOAP7W