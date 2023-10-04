cp /code/meowth/config_template.py /code/meowth/config.py

sed -i -e "s/your_token_here/$BOT_TOKEN/g" /code/meowth/config.py
sed -i -e "s/# 'username' : 'meowth'/'username' : '$PG_USERNAME'/g" /code/meowth/config.py
sed -i -e "s/# 'database' : 'meowth'/'database' : '$PG_DATABASE'/g" /code/meowth/config.py
sed -i -e "s/# 'hostname' : 'localhost'/'database' : '$PG_HOSTNAME'/g" /code/meowth/config.py
sed -i -e "s/'password' : 'password'/'password' : '$PG_PASSWORD'/g" /code/meowth/config.py
cd /code/
python setup.py install
cd /code/meowth/
python launcher.py