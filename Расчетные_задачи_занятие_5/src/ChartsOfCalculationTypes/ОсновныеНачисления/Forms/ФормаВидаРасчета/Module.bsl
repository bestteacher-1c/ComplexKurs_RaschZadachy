
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетСбораБазыПриИзменении(Элемент)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетДанныеГрафикаПриИзменении(Элемент)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюЭлементов()

	Элементы.ГруппаБазовыеВидыРасчета.Видимость = Объект.ТребуетСбораБазы;
	Элементы.ГруппаВедущиеВидыРасчета.Видимость = (Объект.ТребуетСбораБазы Или Объект.ТребуетДанныеГрафика);
	Элементы.ГруппаВытесняющиеВидыРасчета.Видимость = Объект.ТребуетДанныеГрафика;
	
	Элементы.ЗачетОтработанногоВремени.Видимость = Объект.ТребуетДанныеГрафика;
	
	Элементы.ГруппаФормула.Видимость = Объект.СпособРасчета = Перечисления.СпособыРасчета.ПоФормуле;
	
КонецПроцедуры


&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	
	Если Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчета.ПоФормуле") Тогда
	
		Элементы.ГруппаФормула.Видимость = Истина;
	Иначе 
		Элементы.ГруппаФормула.Видимость = Ложь;
		
	
	КонецЕсли;
	
КонецПроцедуры

