
&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	Объект.ПериодРегистрации = НачалоМесяца(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ФизическоеЛицоПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиСрезПоследних.ФизическоеЛицо,
	|	СотрудникиСрезПоследних.Подразделение,
	|	СотрудникиСрезПоследних.Должность,
	|	СотрудникиСрезПоследних.ГрафикРаботы,
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(СотрудникиСрезПоследних.Период, &Дата, ГОД) < 3
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПроцентыВыплатыБольничного._60)
	|		КОГДА РАЗНОСТЬДАТ(СотрудникиСрезПоследних.Период, &Дата, ГОД) >= 3
	|				И РАЗНОСТЬДАТ(СотрудникиСрезПоследних.Период, &Дата, ГОД) < 6
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПроцентыВыплатыБольничного._80)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПроцентыВыплатыБольничного._100)
	|	КОНЕЦ КАК ПроцентВыплаты
	|ИЗ
	|	РегистрСведений.Сотрудники.СрезПоследних(&Дата, ФизическоеЛицо = &ФизическоеЛицо) КАК СотрудникиСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	Запрос.УстановитьПараметр("ФизическоеЛицо", Объект.ФизическоеЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Объект.Подразделение = ВыборкаДетальныеЗаписи.Подразделение;
		Объект.Должность = ВыборкаДетальныеЗаписи.Должность;
		Объект.ГрафикРаботы = ВыборкаДетальныеЗаписи.ГрафикРаботы;
		Объект.ПроцентВыплаты = ВыборкаДетальныеЗаписи.ПроцентВыплаты;
		
	КонецЦикла;

	
КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница.Имя = "Группа4" Тогда
	
		Группа2ПриСменеСтраницыНаСервере();
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Группа2ПриСменеСтраницыНаСервере()
	
	ДГ.Очистить();
	
	Точка = ДГ.УстановитьТочку(Объект.ФизическоеЛицо);
	
	Серия = ДГ.УстановитьСерию("Дни болезни");
	
	ЗначениеДГ = ДГ.ПолучитьЗначение(Точка,Серия);
	Значениедг.Редактирование = Истина;
	
	Интервал = ЗначениеДГ.Добавить();
	
	Интервал.Начало = Объект.ДатаНачала;
	Интервал.Конец = Объект.ДатаОкончания;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ДГПриОкончанииРедактированияИнтервала(Элемент, Интервал, ОтменаРедактирования)
	
	Объект.ДатаНачала 		= Интервал.Начало;
	Объект.ДатаОкончания 	= Интервал.Конец;
	
КонецПроцедуры

