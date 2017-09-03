
[![CircleCI](https://circleci.com/gh/johnboyes/jira-cycle-time.svg?style=svg)](https://circleci.com/gh/johnboyes/jira-cycle-time)

# jira-cycle-time

Export issues' cycle time and other [Control Chart](https://confluence.atlassian.com/agile/glossary/control-chart) data from JIRA.

Cycle time data is very useful for a variety of reporting and forecasting metrics, for instance http://focusedobjective.com/free-tools-resources/

JIRA does provide out of the box [cycle time](https://confluence.atlassian.com/agile/glossary/cycle-time) reporting, but sadly there is [no official way to export the data](https://jira.atlassian.com/browse/JSWSERVER-4288) through the [JIRA REST API](https://docs.atlassian.com/jira-software/REST/cloud).

This Ruby application provides a workaround by accessing the raw data through the "internal" JIRA GreenHopper API, and transforming it into a simple format for export.