""" Tests the loadout.cli module"""

from pytest_mock import MockerFixture

from loadout import cli


def test_says_hello(mocker: MockerFixture) -> None:
    """hello_world() should say hello"""
    print_spy = mocker.patch("builtins.print")

    cli.hello_world()

    print_spy.assert_called_once_with("Hello, world!")
