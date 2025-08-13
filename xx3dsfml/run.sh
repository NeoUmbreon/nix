#!/usr/bin/env bash

# How long to keep HDMI as default
DELAY=10

# --- Get current default sink name ---
current_sink_name=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')

if [[ -z "$current_sink_name" ]]; then
  echo "Could not detect current default sink."
  exit 1
fi

echo "Current default sink: $current_sink_name"

# --- Find HDMI sink name ---
hdmi_sink_name=$(pactl list short sinks | grep -i 'hdmi' | awk '{print $2}')

if [[ -z "$hdmi_sink_name" ]]; then
  echo "Could not find HDMI sink."
  exit 1
fi

echo "Switching default sink to HDMI: $hdmi_sink_name"
pactl set-default-sink "$hdmi_sink_name"

# --- Run the application in background ---
nix run '/home/dawn/flakes/xx3dsfml/' &

# Wait for the delay
echo "Waiting $DELAY seconds before restoring default sink..."
sleep "$DELAY"

# --- Restore original default sink ---
echo "Restoring default sink to $current_sink_name"
pactl set-default-sink "$current_sink_name"
