#!/bin/bash

echo $((RANDOM%(65535-1024+1)+1024))
