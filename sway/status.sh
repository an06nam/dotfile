#!/bin/bash

# ~/.config/sway/status.sh

echo '{"version":1}'
echo '['
echo '[],'

while :; do
  # CPU usage
  cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
  cpu_display="CPU: ${cpu}%"

  # Memory
  mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

  # Network Info
  interface=$(nmcli -t -f DEVICE,STATE dev | awk -F: '$2 == "connected" {print $1}' | head -n1)
  ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1 == "yes" {print $2}')
  ip=$(ip -4 addr show "$interface" | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1)
  signal=$(nmcli -t -f active,signal dev wifi | awk -F: '$1 == "yes" {print $2}')
  wifi_info="Wi-Fi: ${ssid:-N/A} (${signal:-0}%)"

  # Volume
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  vol_display="Vol: $volume"
  [ "$mute" = "yes" ] && vol_display="Vol: Muted"

  # Brightness
  brightness=$(brightnessctl get)
  max_brightness=$(brightnessctl max)
  percent=$((brightness * 100 / max_brightness))
  bright_display="Brightness: ${percent}%"

  # Time
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  # Print JSON block
  echo "[
    {\"full_text\": \"${cpu_display//\"/\\\"}\"},
    {\"full_text\": \"MEM: ${mem//\"/\\\"}\"},
    {\"full_text\": \"${wifi_info//\"/\\\"}\"},
    {\"full_text\": \"IP: ${ip//\"/\\\"}\"},
    {\"full_text\": \"${vol_display//\"/\\\"}\"},
    {\"full_text\": \"${bright_display//\"/\\\"}\"},
    {\"full_text\": \"${datetime//\"/\\\"}\"}
  ],"

  sleep 2
done

