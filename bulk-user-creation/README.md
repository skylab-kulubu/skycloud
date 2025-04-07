# Usage

bash create-users.sh users.csv

## Example CSV File

```csv
Name Surname,name.surname@domain.tld
Name Surname 2,name.surname@domain.tld
John Doe,john.doe@domain.tld
```

## Script

```bash
while IFS=',' read -r display_name email; do
  username=${email%@*}
  echo "$display_name, $email, $username"
  docker compose exec -T nextcloud-app php occ user:add --generate-password --display-name "$display_name" --email $email -g "GROUP NAME 2" -g "GROUP NAME 1" $username
done <$1
```
