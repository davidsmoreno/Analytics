# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 18:54:59 2023

@author: David
"""

def cuadrada(x):
    return x**2


x=[1,2,3,4,5,6,7,8,9]

x_2=[]
for i in x:
    x_2.append(cuadrada(i))
    



dt=0.1

integral=[]
for i in x:
    integral.append((cuadrada(i+dt)-cuadrada(i))/dt )


import matplotlib.pyplot as plt


# Create a figure and axis
fig, ax = plt.subplots()

# Plot the first data series (x_2)
ax.plot(x, x_2, label='x_2', marker='o', linestyle='-', color='blue')

# Plot the second data series (integral)
ax.plot(x, integral, label='integral', marker='s', linestyle='--', color='red')

# Add labels and a legend
ax.set_xlabel('X-axis Label')
ax.set_ylabel('Y-axis Label')
ax.set_title('Beautiful Graph with Two Lists')
ax.legend()

# Customize the appearance
ax.grid(True)
ax.set_facecolor('#f0f0f0')

# Show the plot
plt.show()





















