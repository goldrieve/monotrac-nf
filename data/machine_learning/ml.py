import pandas as pd 
from sklearn.model_selection import train_test_split 
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report 
from sklearn.ensemble import RandomForestClassifier 
import joblib 
from sklearn.model_selection import cross_val_score


meta_data = pd.read_csv('combined_competency.csv', sep=',')
x = meta_data.drop(columns=['isolate', 'Competence'])
y = meta_data['Competence']

# Splitting the data into training and test data 
train_x, test_x, train_y, test_y = train_test_split (x, y, test_size=0.2, random_state=42)   
 
i=RandomForestClassifier()
cross_val_score(i, x, y, cv=10).mean()

i.fit(train_x, train_y)
joblib.dump(i, 'ml.pkl')
y_pred = i.predict(test_x)

print("\nAccuracy Score:")
print(accuracy_score(test_y, y_pred))
print("\nConfusion Matrix:")
print(confusion_matrix(test_y, y_pred))
print("\nClassification Report:")
print(classification_report(test_y, y_pred))