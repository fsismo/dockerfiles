#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Por favor ejecutar como root o con sudo"
  exit
fi
