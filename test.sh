#!/bin/bash

file="helmrelease.yaml"
CHART_NAME=$(yq e 'select(document_index == 1).spec.chart.spec.chart' $file)
CHART_VERSION=$(yq e 'select(document_index == 1).spec.chart.spec.version' $file)
REPO_NAME=$(yq e 'select(document_index == 1).spec.chart.spec.sourceRef.name' $file)
REPO_URL=$(yq e 'select(document_index == 0).spec.url' $file)

echo "$CHART_NAME $CHART_VERSION $REPO_NAME $REPO_URL"