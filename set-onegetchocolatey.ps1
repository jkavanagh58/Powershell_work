<<<<<<< HEAD
﻿if (!(get-packagesource -Name Chocolatey)){
    Register-PackageSource -Name chocolatey -Provider chocolatey -Trusted –Location http://chocolatey.org/api/v2/
}
# Validate Chocolatey is trusted
if (!(get-packagesource Chocolatey).IsTrusted){Set-PackageSource chocolatey -Trusted -Verbose }
# Start installing software
if (!(get-package -name sysinternals -ErrorAction SilentlyContinue)){
    install-package sysinternals -Confirm:$false 
}
=======
﻿if (!(get-packagesource -Name Chocolatey)){
    Register-PackageSource -Name chocolatey -Provider chocolatey -Trusted –Location http://chocolatey.org/api/v2/
}
# Validate Chocolatey is trusted
if (!(get-packagesource Chocolatey).IsTrusted){Set-PackageSource chocolatey -Trusted -Verbose }
# Start installing software
if (!(get-package -name sysinternals -ErrorAction SilentlyContinue)){
    install-package sysinternals -Confirm:$false 
}
>>>>>>> origin/master
