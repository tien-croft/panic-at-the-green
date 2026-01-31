extends GutTest


# Test to verify GUT is working properly
func test_gut_is_working():
	assert_true(true, "GUT should be able to run tests")


func test_basic_math():
	assert_eq(2 + 2, 4, "Basic math should work")
	assert_ne(2 + 2, 5, "Incorrect math should be caught")
