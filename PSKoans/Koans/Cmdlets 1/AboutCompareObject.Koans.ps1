using module PSKoans
[Koan(Position = 204)]
param()
<#
    Compare-Object

    Compare-Object is primarily for comparing collections of objects rather than individual
    items, and is usually used to display data comparisons to the user.
#>
Describe 'Compare-Object' {

    It 'compares collections of objects' {
        $Comparison = @{
            ReferenceObject  = 'this', 'is', 'the', 'reference'
            DifferenceObject = 'these', 'is', 'the', 'difference'
        }
        $CompareData = Compare-Object @Comparison
        'these' | Should -Be $CompareData[0].InputObject
        '=>' | Should -Be $CompareData[0].SideIndicator
        $CompareData[0] | Should -BeOfType System.Object
    }

    It 'can display items that occur in both sets' {
        # By default, items that are the same in both collections are hidden.
        $Comparison = @{
            ReferenceObject  = 'this', 'is', 'the', 'reference'
            DifferenceObject = 'these', 'is', 'the', 'difference'
        }
        $CompareData = Compare-Object @Comparison -IncludeEqual
        $CompareData.SideIndicator -contains '==' | Should -BeTrue
        '==' | Should -Be $CompareData.Where{$_.InputObject -eq 'the'}.SideIndicator
    }
}
