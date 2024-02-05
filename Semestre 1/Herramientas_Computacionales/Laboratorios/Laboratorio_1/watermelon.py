def watermelon(w):
    for a in range(1,w):
        for b in range(1,w):
            if a+b==w:
                if a%2==0 and b%2==0:
                    print("YES")
                    print(a,b)
                    return
                    
    print("NO")
    print(w)




for i in range(1,80):
    prueba=watermelon(i)

prueba=watermelon(80)