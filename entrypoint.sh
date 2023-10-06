cp /code/meowth/config_template.py /code/meowth/config.py

if [ -e "$BOT_TOKEN_FILE" ]; then BOT_TOKEN=$(cat $BOT_TOKEN_FILE); fi
if [ -e "$BOT_MASTER_FILE" ]; then BOT_MASTER=$(cat $BOT_MASTER_FILE); fi 
if [ -e "$PG_PASSWORD_FILE" ]; then PG_PASSWORD=$(cat $PG_PASSWORD_FILE); fi
if [ -e "$GMAPS_API_KEY_FILE" ]; then GMAPS_API_KEY=$(cat $GMAPS_API_KEY_FILE); fi

sed -i -e "s/your_token_here/$BOT_TOKEN/g" /code/meowth/config.py
sed -i -e "s/bot_master = 12345678903216549878/bot_master = $BOT_MASTER/g" /code/meowth/config.py

sed -i -e "s/gmaps_api_key = 'apikeygoeshere'/gmaps_api_key = '$GMAPS_API_KEY'/g" /code/meowth/exts/map/map_info.py

sed -i -e "s/# 'username' : 'meowth'/'username' : '$PG_USERNAME'/g" /code/meowth/config.py
sed -i -e "s/# 'database' : 'meowth'/'database' : '$PG_DATABASE'/g" /code/meowth/config.py
sed -i -e "s/# 'hostname' : 'localhost'/'hostname' : '$PG_HOSTNAME'/g" /code/meowth/config.py
sed -i -e "s/'password' : 'password'/'password' : '$PG_PASSWORD'/g" /code/meowth/config.py
cd /code/
python setup.py install
cd /code/meowth/
python launcher.py -d -r