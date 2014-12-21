Feature:
  As a Ruby developer
  I want to capture the state changes that occur on an object
  So that I can apply the same history to a new instance to make it identical
    
    Scenario: Replaying History on a New Object
      Given I have a module "MyModule":
      """
      class MyClass
        prop_accessor :my_foo
      end
      """
      When I new up a "MyClass" as my subject
      And I alter it by "my_foo = 5"
      And I alter it by "my_foo + 3"
      And I replay its history on a new "MyClass" subject
      Then its "my_foo" should be "8"
