import bcrypt
stored_hash = b"$2b$10$LCEbpiosmdiVlL3/Ex4o.uu.ASF4asMpQGeX.kx0WCqq4JOqE.7My"
print(f"'1235' matches: {bcrypt.checkpw(b'1235', stored_hash)}")
