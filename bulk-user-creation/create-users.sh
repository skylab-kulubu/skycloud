#!/bin/bash
input_file="$1"

# Convert CRLF to LF (if needed) and skip header + empty lines
while IFS=',' read -r display_name email || [ -n "$display_name" ]; do
  # Skip empty or invalid lines
  [ -z "$display_name" ] || [ -z "$email" ] && continue

  # Trim whitespace
  display_name=$(echo "$display_name" | xargs)
  email=$(echo "$email" | xargs)

  # Extract username (part before @)
  username="${email%@*}"

  echo "Adding: $display_name ($email) with username: $username"
  docker compose exec -T nextcloud-app php occ user:add \
    --generate-password \
    --display-name "$display_name" \
    --email "$email" \
    -g "YILDIZ JAM EKİP" \
    -g "TÜM ÜYELER" \
    "$username" </dev/null
done < <(sed 's/\r$//' "$input_file" | grep -v "^$" | tail -n +2)
