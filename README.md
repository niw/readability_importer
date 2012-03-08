Readability Importer
====================

A simple command to import many URLs to [Readability](http://www.readability.com/).

Install
-------

This command is provided in RubyGems format.
Run next command to insall all dependencies and command.

    gem install redability_importer

Usage
-----

To import [Instapaper](http://www.instapaper.com/) URL(s),
export Instapaper CSV, then run next command.

    redability_importer import -e <Your Readability Email Address> --instapaper-csv <Path to CSV>

You can grab your Readability email address in [My Account](https://www.readability.com/account/email) page.

If you have a file includes a URL per line,
also you can use ``--urls`` option.

    cat path_to_file | readability_importer import -e <Your Readability Email Address> --urls -

Or, just simply assign URLs.

    readability_importer import -e <Your Readability Email Address> --urls http://a.com http://b.com

Note
----

This command is, of course, unofficial tool.
Please do *NOT* contact with Readability about this tool.
Also, use at your own risk.
