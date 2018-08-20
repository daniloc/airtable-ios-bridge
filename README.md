# airtable-ios-bridge

An Objective-C wrapper for the Airtable API using `NSURLSession` and friends. Example Swift project with bridging header included.

## Do not use this in a production app.

Airtable's rate limit is impossible to enforce across apps—more than a few concurrent users would lock down the API immediately.

This project exists to facilitate building prototypes and internal tools with Airtable as a cloud backend.
