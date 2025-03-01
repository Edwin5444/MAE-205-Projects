data = [16 28 10 5 11 8 22 17]
produce  = {'Oranges','Apples','Bananas','Lettuce','Cabbage','Onions','Tomatoes','Potatoes'}
Adata = sort(data,'ascend');
Ddata = sort(data,'descend');
[Ddata, idx] = sort(data, 'descend');
[Adata, as] = sort(data, 'ascend');
produce_sorted = char(produce(idx));
produce_sorted1 = char(produce(as));


subplot(2, 2, 1)
view = [0 1 0 1 0 1 0 1];
pie(data,view)
pie(data)
legend(produce)

subplot(2, 2, 2)
view = [0 1 0 1 0 1 0 1];
pie(data,view)
legend(produce)

subplot(2, 2, 3)
bar([1, 2, 3, 4, 5, 6, 7, 8],Adata)
set(gca,'XTickLabel', produce_sorted1)

subplot(2, 2, 4)
barh([1, 2, 3, 4, 5, 6, 7, 8],Ddata)
set(gca,'YTickLabel', produce_sorted)
