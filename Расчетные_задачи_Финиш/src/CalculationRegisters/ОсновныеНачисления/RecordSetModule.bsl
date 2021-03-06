Процедура ПередЗаписью(Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов)
	
	//Проверяем предыдущую версию набора записей, записанную в базу данных
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОсновныеНачисления.ПериодРегистрации
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
		|ГДЕ
		|	ОсновныеНачисления.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Если ВыборкаДетальныеЗаписи.ПериодРегистрации <>
			Константы.ТекущийПериод.Получить() Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя менять данные предыдущих периодов";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;
		
		КонецЕсли;
		
	КонецЦикла;
	
	
	//Проверяем текущий набор записей

	Если Количество() > 0 Тогда
		
		Если Получить(0).ПериодРегистрации <> Константы.ТекущийПериод.Получить() Тогда
		
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя записывать данные предыдущих периодов";
			Сообщение.Сообщить();
			
			Отказ = Истина;
		
		КонецЕсли;
		
	
	КонецЕсли;
	
	
КонецПроцедуры
