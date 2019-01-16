# List specifications

This document details how we display the data for each type of object list and any variations (such as current).  Lists are constructed using the ListPageSerializer.  Cards are constructed using the CardFactory.

### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Availability Type](#availability-type)
  - [List item (card)](#list-item-card)
- [Group](#group)
  - [List item (card)](#list-item-card-1)
- [Laid Paper](#laid-paper)
  - [List item (card)](#list-item-card-2)
- [Laying Body](#laying-body)
- [Made Available](#made-available)
  - [List item (card)](#list-item-card-3)
- [Paper Type](#paper-type)
  - [List item (card)](#list-item-card-4)
- [Procedure](#procedure)
  - [List item (card)](#list-item-card-5)
- [Procedure Step](#procedure-step)
  - [List item (card)](#list-item-card-6)
- [Proposed Negative Statutory Instrument](#proposed-negative-statutory-instrument)
  - [List item (card)](#list-item-card-7)
- [Statutory Instrument](#statutory-instrument)
  - [List item (card)](#list-item-card-8)
- [Work Package](#work-package)
  - [List item (card)](#list-item-card-9)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Availability Type

### List item (card)
* availability type (heading)

## Group

### List item (card)
* groupName (heading)

## Laid Paper
List built using the LaidThingListComponentsFactory.

### List item (card)
* type (small - optional)
* laidThingName (heading)
* layingDate (description list item)
* layingBody (description list item - optional depending on the context)
* procedureName (description list item - optional depending on the context)

## Laying Body
See [Group](#group).

## Made Available
List built using the LaidThingListComponentsFactory.  (This will need to change once there are other types of things made available.)

### List item (card)
* type (small - optional)
* laidThingName (heading)
* layingDate (description list item)
* layingBody (description list item - optional depending on the context)
* procedureName (description list item - optional depending on the context)

## Paper Type

### List item (card)
* paper type (heading)

## Procedure

### List item (card)
* procedureName (heading)

## Procedure Step
List built using the ProcedureStepListComponentsFactory.

### List item (card)
* procedureStepName (heading)
* houseName (description list item)

## Proposed Negative Statutory Instrument
List built using the LaidThingListComponentsFactory.

### List item (card)
* type (small - optional)
* laidThingName (heading)
* layingDate (description list item)
* layingBody (description list item - optional depending on the context)
* procedureName (description list item - optional depending on the context)

## Statutory Instrument
List built using the LaidThingListComponentsFactory.

### List item (card)
* type (small - optional)
* laidThingName (heading)
* layingDate (description list item)
* layingBody (description list item - optional depending on the context)
* procedureName (description list item - optional depending on the context)

## Work Package
List built using the WorkPackageListComponentsFactory.

### List item (card)
* type (small - optional)
* workPackagedThingName (heading - link)
* procedureName (description list item - optional depending on the context)
* layingDate (description list item)

