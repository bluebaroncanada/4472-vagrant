## How to setup putty for maximum production

Go to http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html and download `putty` and `puttygen`.  Just save them right to `c:\windows` and ignore the protest messages.


- Open `puttygen`.  Click `Generate` and move your mouse around until the bar gets full.
- Save both your public and private key WITHOUT a passphrase.  Copy the text of the Public key and after you've cloned this projectect, edit the `provisioning.bash` script, remove the new line character, and paste it all in one line where it says `ssh_public_key`.

It should look like:

```
ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDZC0wINCffUgIYbD7RznR1dMV4bTbkzW5JWp7bsTNWZNTUGiXt9nKl7Q+fE8ChpnqsLfQg4NtzxkMxFEOZI3qa/6dLlqlIq5UwdB/lF0YO7FMgn5sfJs2+/pvs2Ytx6niH4coLB8NZW5SiV9MWj3ECOOVWTtVyrU37/ANzCr+i+tU8g7H2+DxADXUcYWxwbv2tL1TF89BEaRaVQlz1oJNi54i+E/aggyw65WfoVDWQEXWO+SjiTm9Ide1RxHE0pDUKLoxTvsUZpR2PWRq0LCrzljfzfYl3RloCIelwy+pFgO8KlDgPvgnJs8iP6wmsMw5RyF5y3fhYWdET/h377jl"
```

- Run the `vagrant-putty.reg` file.
- Open up putty.  Load the `4472-vagrant` entry but don't click open.  Just load.
- On the left hand side click the + beside `SSH`.
- Highlight `Auth` but don't open it.
- On the right hand side click browse and point it to where you saved your PRIVATE key.  Not the public key this time.
- Go back up to the top on the left hand side and highlight `Session`.
- Click Save.
