#!/bin/bash

# ~/.config/sway/status.sh

echo '{"version":1}'
echo '['
echo '[],'

# Track notification state to avoid spamming
notified_low_battery=0

while :; do
  # CPU usage
  cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
  cpu_display="🖥️ CPU: ${cpu}%"

  # CPU Temp
  cpu_temp=$(sensors | awk '/^Package id 0:/ {print $4}' | tr -d '+°C')
  if [ -z "$cpu_temp" ]; then
    # Fallback: use first "Core 0" if no package info
    cpu_temp=$(sensors | awk '/Core 0/ {print $3}' | tr -d '+°C')
  fi
  cpu_temp_display="🌡️ ${cpu_temp}°C"

  # Memory
  mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
  mem_display="🧠 MEM: ${mem}"

  # Network Info
  interface=$(nmcli -t -f DEVICE,STATE dev | awk -F: '$2 == "connected" {print $1}' | head -n1)
  ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1 == "yes" {print $2}')
  ip=$(ip -4 addr show "$interface" | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1)
  signal=$(nmcli -t -f active,signal dev wifi | awk -F: '$1 == "yes" {print $2}')
  wifi_info="📶 ${ssid:-N/A} (${signal:-0}%)"
  ip_display="🌐 IP: ${ip}"

  # Volume
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  if [ "$mute" = "yes" ]; then
    vol_display="🔇 Muted"
    vol_color="#FF5555"
  else
    vol_display="🔊 Vol: $volume"
    vol_color="#FFFFFF"
  fi

  # Brightness
  brightness=$(brightnessctl get)
  max_brightness=$(brightnessctl max)
  percent=$((brightness * 100 / max_brightness))
  bright_display="🌞 ${percent}%"

  # Battery
  battery_device=$(upower -e | grep battery | head -n1)
  if [ -n "$battery_device" ]; then
    battery_info=$(upower -i "$battery_device")
    battery_percentage=$(echo "$battery_info" | awk '/percentage:/ {print $2}' | tr -d '%')
    battery_state=$(echo "$battery_info" | awk '/state:/ {print $2}')
    
    # Remaining time
    if [ "$battery_state" = "charging" ]; then
      time_remaining=$(echo "$battery_info" | awk -F': ' '/time to full/ {print $2}')
      battery_emoji="🔌"
      battery_color="#00FF00"
    else
      time_remaining=$(echo "$battery_info" | awk -F': ' '/time to empty/ {print $2}')
      battery_emoji="🔋"
      if [ "$battery_percentage" -lt 15 ]; then
        battery_color="#FF0000"
        if [ "$notified_low_battery" -eq 0 ]; then
          notify-send -u critical "⚠️ Low Battery" "Battery is at ${battery_percentage}%"
          notified_low_battery=1
        fi
      elif [ "$battery_percentage" -lt 50 ]; then
        battery_color="#FFA500"
        notified_low_battery=0
      else
        battery_color="#FFFFFF"
        notified_low_battery=0
      fi
    fi

    # Final battery text
    if [ -n "$time_remaining" ]; then
      battery_display="${battery_emoji} Battery: ${battery_percentage}% (${battery_state}, ${time_remaining})"
    else
      battery_display="${battery_emoji} Battery: ${battery_percentage}% (${battery_state})"
    fi
  else
    battery_display="Battery: N/A"
    battery_color="#888888"
  fi

  # Time
  datetime=$(date '+📅 %Y-%m-%d 🕒 %H:%M:%S')

  # Print JSON block
  echo "[
    {\"full_text\": \"${cpu_display//\"/\\\"}\"},
    {\"full_text\": \"${cpu_temp_display//\"/\\\"}\"},
    {\"full_text\": \"${mem_display//\"/\\\"}\"},
    {\"full_text\": \"${wifi_info//\"/\\\"}\"},
    {\"full_text\": \"${ip_display//\"/\\\"}\"},
    {\"full_text\": \"${vol_display//\"/\\\"}\", \"color\": \"${vol_color}\"},
    {\"full_text\": \"${bright_display//\"/\\\"}\"},
    {\"full_text\": \"${battery_display//\"/\\\"}\", \"color\": \"${battery_color}\"},
    {\"full_text\": \"${datetime//\"/\\\"}\"}
  ],"

  sleep 2
done
