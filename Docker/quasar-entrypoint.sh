#!/bin/bash

cp -r /cache/node_modules /app/.

yarn quasar clean;
yarn quasar dev -m spa;