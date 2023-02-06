#!python3
import sys
import csv
from faker import Faker

fake = Faker()
number_of_records = int(sys.argv[1])

csvout = csv.writer(sys.stdout, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

csvout.writerow(['first_name', 'last_name', 'age'])

for _ in range(number_of_records):
    csvout.writerow([fake.first_name(), fake.last_name(), fake.numerify("@#")])