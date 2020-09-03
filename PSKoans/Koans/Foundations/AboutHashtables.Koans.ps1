using module PSKoans
[Koan(Position = 120)]
param()
<#
    Hashtables

    Hashtables are a more advanced type of collection than arrays, and use string keys as a kind of
    'index' rather than index numbers. A simple PowerShell hashtable can be created with a hash
    literal, which looks like this:

    @{
        Key  = 'Value'
        Age  = 12
        Name = "Robert '); DROP TABLE 'STUDENTS'"
    }

    Hashtables are more difficult to iterate over than arrays, but have the advantage of being able
    to more easily access exactly the item you want from the collection. In the above example, it's
    quite simple to access only the Age or Name value, as you please.

    Hashtables are also frequently used as input to many more customisable parameters for
    PowerShell cmdlets.
#>
Describe 'Hashtables' {

    Context 'Building Hashtables' {

        It 'can be built with a hash literal' {
            # A hash literal is similar to the array literal @(), just with curly braces
            $Hashtable = @{
                # Hashtables always consist of key/value pairs
                Name     = 'Hashtable'
                Color    = 'Blue'
                Spectrum = 'Ultraviolet'
            }

            # Values in the hashtable can be retrieved by specifying their corresponding key
            'Blue' | Should -Be $Hashtable['Color']
            'Ultraviolet' | Should -Be $Hashtable['Spectrum']

            $Hashtable | Should -BeOfType [hashtable]
        }

        It 'can be built all in one line' {
            $Hashtable = @{ Name = 'Bob'; Species = 'Tardigrade'; Weakness = 'Phys' }

            'Tardigrade' | Should -Be $Hashtable['Species']
        }

        It 'can be built in pieces' {
            $Hashtable = @{ }
            # By specifying a key, we can insert or overwrite values in the hashtable
            $Hashtable['Name'] = 'Hashtable'
            $Hashtable['Color'] = 'Red'
            $Hashtable['Spectrum'] = 'Infrared'
            $Hashtable['Spectrum'] = 'Microwave'

            'Red' | Should -Be $Hashtable['Color']
            'Microwave' | Should -Be $Hashtable['Spectrum']
        }

        It 'can be built using the Hashtable object methods' {
            $Hashtable = @{ }
            $Hashtable.Add('Name', 'John')
            $Hashtable.Add('Age', 52)
            $Hashtable.Add('Radiation', 'Infrared')

            52 | Should -Be $Hashtable['Age']
        }
    }

    Context 'Working with Hashtables' {

        It 'is a reference type' {
            <#
                Like many objects, hashtables typically get passed by reference;
                assigning the object to another variable does not create a second copy,
                only a second way to refer to the original object.
            #>
            $HashtableOne = @{
                Name = 'Jim'
                Age  = 12
            }

            $HashtableTwo = $HashtableOne
            $HashtableTwo['Age'] = 21

            $HashtableOne['Age'] | Should -Be 21 # Or is it?
            21 | Should -Be $HashtableTwo['Age']
        }

        It 'can be cloned' {
            # Instead of passing a reference to the original, we can copy it!
            $HashtableOne = @{
                'Meal Type' = 'Dinner'
                Calories    = 1287
                Contents    = 'Carrots', 'Fish', 'Gherkin', 'Rice', 'Celery'
            }
            $HashtableTwo = $HashtableOne.Clone()
            $HashtableTwo['Meal Type'] = 'Snack'
            $HashtableTwo['Calories'] = 250
            $HashtableTwo['Contents'] = 'Chips'

            'Dinner' | Should -Be $HashtableOne['Meal Type']
            1287 | Should -Be $HashtableOne['Calories']

            'Chips' | Should -Be $HashtableTwo['Contents']
        }

        It 'allows you to retrieve a list of keys or values' {
            $Hashtable = @{ One = '1'; Two = '2'; Three = '3'; Four = '4' }

            @( 'One', 'Two', 'Three', 'Four' ) | Should -BeIn $Hashtable.Keys
            @( '1', '2', '3', '4' ) | Should -BeIn $Hashtable.Values
        }

        It 'is not ordered' {
            # Hashtables are ordered by hashing their keys for extremely quick lookups.
            $Hashtable = @{ One = 1; two = 2; Three = 3; Four = 4 }

            <#
                You will find your key/value pairs are often not at all in the order you entered them.
                Trying to predict the order of the pairs like this can be very difficult.
                The following assertions would be highly likely to fail.

                    $Hashtable.Keys | Should -Be @('One', 'Two', 'Three', 'Four')
                    $Hashtable.Values | Should -Be @(1, 2, 3, 4)

                The order can and will change again, as well, if the collection is altered.
            #>

            $Hashtable['Five'] = 5

            $Hashtable.Keys | Should -Not -Be @('One', 'Two', 'Three', 'Four', 'Five')
            $Hashtable.Values | Should -Not -Be @(1, 2, 3, 4, 5)

            $Hashtable.Keys | Should -BeIn @('One', 'Two', 'Three', 'Four', 'Five')
        }

        It 'can be forced to retain order' {
            <#
                The [ordered] tag is only valid when paired with a hashtable literal declaration;
                it's not a valid type on its own.
            #>
            $Hashtable = [ordered]@{ One = 1; Two = 2; Three = 3; Four = 4 }

            <#
                Order comes at a price; in this case, lookup speed is significantly decreased with
                ordered hashtables.
                Does this leave our keys and values in the order you would expect?
            #>
            @( 'One', 'Two', 'Three', 'Four' ) | Should -Be $Hashtable.Keys.ForEach{ $_ }
            @( 1, 2, 3, 4 ) | Should -Be $Hashtable.Values.ForEach{ $_ }

            # The [ordered] tag is not in itself properly a type, but changes the type of the object completely.
            'System.Collections.Specialized.OrderedDictionary' | Should -Be $Hashtable.GetType().FullName
        }

        It 'allows you to remove keys' {
            $Hashtable = @{
                One   = 1
                Two   = 2
                Three = 3
                Four  = 4
            }

            $Hashtable.Remove('One')

            3 | Should -Be $Hashtable.Count
            $Hashtable.Keys | Should -BeIn @('Two', 'Three', 'Four')
            $Hashtable.Values | Should -BeIn @( 2, 3, 4)
        }

        It 'can check if keys or values are present in the hashtable' {
            # Enter keys and values in this table to make the below tests pass.
            # You should not need to modify the `Should` assertions themselves.
            $Hashtable = @{
                # Example:
                # KeyName = Value
                Carrots = 'Fruit'
                Oranges = 'Fruit'
            }

            $Hashtable.ContainsKey('Carrots') | Should -BeTrue
            $Hashtable.ContainsValue('Fruit') | Should -BeTrue

            $Hashtable['Oranges'] | Should -Be 'Fruit'
            $Hashtable['Carrots'] | Should -Be $Hashtable['Oranges']
        }

        It 'will not implicitly convert keys and lookup values' {
            $Hashtable = @{ 0 = 'Zero' }

            'Zero' | Should -Be $Hashtable[0]
            $null | Should -Be $Hashtable['0']
        }

        It 'can access values by using keys like properties' {
            $Hashtable = @{ 0 = 'Zero'; Name = 'Jim' }
            $Key = 'Name'

            'Zero' | Should -Be $Hashtable.0
            'Jim' | Should -Be $Hashtable.$Key
        }
    }
}
