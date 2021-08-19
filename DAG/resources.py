from configparser import ConfigParser
# from dagster import resource, Field, String
import pandas as pd
import numpy as np
import sqlalchemy
import datetime
import uuid

file = 'C:/Users/User/Source/config/config.ini'
config = ConfigParser()
config.read(file)


class db_connection(object):
    """
    Class for basic database interactions that will be used when copying data to a postgres environment.

    """

    def __init__(self, db_name: str):
        self.db_name = db_name

        self.flavor, self.engine, self.conn, self.cursor = self.create_connection()

    def create_connection(self):
        db_name = self.db_name
        flavor = ''
        connstring = ''
        if db_name == 'main':
            flavor = 'postgres'
            connstring = config['main']['Database'] + '://' + \
                         config['main']['User'] + ':' + \
                         config['main']['Password'] + '@' + \
                         config['main']['Server'] + ':' + \
                         config['main']['Port'] + '/' + \
                         config['main']['dbname']


        # print(connstring)
        engine = sqlalchemy.create_engine(connstring)
        conn = engine.raw_connection()
        cursor = conn.cursor()


        return flavor, engine, conn, cursor


def db_connect(db_name):
    return db_connection(db_name)


class solid_metadata(object):
    """
    Class for logging solid metadata.
    uuid.uuid4()
    """

    def __init__(self, owner='', solidname='', solidid='', source='', destinationschema='', destinationtable='',
                 etl_date='', rows='', runtime=''):
        self.owner = owner
        self.solidname = solidname
        self.solidid = solidid
        self.source = source
        self.destinationschema = destinationschema
        self.destinationtable = destinationtable
        self.etl_date = etl_date
        self.rows = rows
        self.runtime = runtime


def new_solid_metadata(owner, solidname, solidid, source, destinationschema, destinationtable):
    return solid_metadata(owner=owner
                          , solidname=solidname
                          , solidid=solidid
                          , source=source
                          , destinationschema=destinationschema
                          , destinationtable=destinationtable)



def etl_log(sld_metadata,db_class):
    i = '''
    insert into new_glenn_public.etl_log (owner,solidid,source,destinationtable,etl_date,rows,runtime) values
    ('{}','{}','{}','{}','{}','{}','{}')
    '''.format(sld_metadata.owner
               , sld_metadata.solidid
               , sld_metadata.source
               , sld_metadata.destinationtable
               , sld_metadata.etl_date
               , sld_metadata.rows
               , sld_metadata.runtime
               )

    db_class.cursor.execute(i)
    return db_class.conn.commit()

