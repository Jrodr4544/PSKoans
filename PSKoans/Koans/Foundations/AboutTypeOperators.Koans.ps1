﻿using module PSKoans
[Koan(Position = 119)]
param()
<#
    Type Operators

    -is and -isnot are used to verify the type of an object, whereas -as is used to cast or convert
    an object to another type entirely.

    For more detailed information, refer to 'Get-Help about_Type_Operators'
#>
Describe 'Type Operators' {

    Context 'Is and IsNot Operators' {

        It 'examines the type of the left hand object' {
            45 -isnot [double] | Should -BeTrue
            'string' -is [string] | Should -BeTrue
        }

        It 'is useful for determining available methods' {
            $Value = 2.5 

            if ($Value -is [double]) {
                [double] | Should -Be $Value.GetType()
            }
            else {
                Should -Fail -Because '$Value was not the correct type.'
            }
        }
    }

    Context 'As Operator' {

        It 'is used to convert objects to other types' {
            $Value = '2'
            $Value | Should -BeOfType [string]

            $NewValue = $Value -as [int]
            $NewValue | Should -BeOfType int32
        }

        It 'is similar to casting' {
            $String = '04'
            $Number = [int] $String
            $Number2 = $String -as [int]

            $Number | Should -Be $Number2
            $Number | Should -BeOfType int32 
        }

        It 'does not throw errors on a failed conversion' {
            $Casting = {
                [int]'string'
            }
            $Conversion = {
                'string' -as [int]
            }

            $Casting | Should -Throw -ErrorId 'InvalidCastFromStringToInteger'
            $Conversion | Should -Not -Throw
            $null | Should -Be $Conversion.InvokeReturnAsIs()
        }
    }
}
