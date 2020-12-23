function out = myFactorial(n)

if n > 1
    out = n.*myFactorial(n-1);
else
    out = 1;
end