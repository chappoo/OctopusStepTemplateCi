<#
Copyright 2016 ASOS.com Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

<#
.NAME
	Get-VariableStatement.Tests

.SYNOPSIS
	Pester tests for Get-VariableStatement.
#>
Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-VariableStatement" {
    BeforeEach {
        $tempFile = [System.IO.Path]::GetTempFileName() # Cant use the testdrive as $doc.Save($Path) doesn't support 'TestDrive:\'
        Set-Content $tempFile @"
function test {
    `$myTestVariable = 'some value'
    Write-Host `$myTestVariable
}
"@
    }
    AfterEach {
        Remove-Item $tempFile
    }
    
    It "Should return the variable statement from a powershell script" {
        Get-VariableStatement -Path $tempFile -VariableName "myTestVariable" -Type Statement | Should Be "`$myTestVariable = 'some value'" 
    }
    
    It "Should return the value of the variable statement from a powershell script" {
        Get-VariableStatement -Path $tempFile -VariableName "myTestVariable" -Type Value | Should Be "'some value'" 
    }
    
    It "Should return nothing if the variable doesnt exist" {
        Get-VariableStatement -Path $tempFile -VariableName "null" -Type Value | Should Be $null
    }
}
