
Функция ПолучитьПроцентВыплатыЧислом(ПроцентСсылка) Экспорт

	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._100, 100);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._60, 60);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._80, 80);

	Возврат Соответствие.Получить(ПроцентСсылка);
	
КонецФункции // ПолучитьПроцентВыплатыЧислом()


// Процедура - Перед записью РРПеред записью
//
// Параметры:
//  Источник							 - РегистрРасчетаНаборЗаписей  	 -  
//  Отказ								 - Булево	 - 
//  Замещение							 - Булево	 - Определяет режим замещения существующей записи 
//  ТолькоЗапись						 - Булево	 - Определяет режим записи набора
//  ЗаписьФактическогоПериодаДействия	 - Булево	 - Если ЛОЖЬ ,то при записи набора записей фактический период действия не рассчитывается
//  ЗаписьПерерасчетов					 - Булево	 - Если ЛОЖЬ, то при записи набора записей перерасчеты не регистрируются
//
Процедура ПередЗаписьюРРПередЗаписью(Источник, Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов) Экспорт
	
	Возврат;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОсновныеНачисления.ПериодРегистрации
	|ИЗ
	|	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
	|ГДЕ
	|	ОсновныеНачисления.Регистратор = &Регистратор";
		
	//--Меняем текст запроса 
	
	#Область СхемаЗапроса
		
		ИмяРегистра = Источник.Метаданные().Имя; //Читаем из метаданных имя регистра
		
		СхемаЗапроса = Новый СхемаЗапроса;
		
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		
		ТаблицыЗапроса_Из = СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Источники;
		
		НоваяДоступнаяТаблица = СхемаЗапроса.ПакетЗапросов[0].ДоступныеТаблицы.Найти("РегистрРасчета." + ИмяРегистра);
		
		ТаблицыЗапроса_Из.Заменить(0,НоваяДоступнаяТаблица);
		
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		
		//--Изменили текст запроса
	#КонецОбласти 
	
	ТекПериод = Константы.ТекущийПериод.Получить();
		
		
	Запрос.УстановитьПараметр("Регистратор", Источник.Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Если ВыборкаДетальныеЗаписи.ПериодРегистрации <> ТекПериод Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя менять данные другого периода. Текущий период " + Формат(ТекПериод,"ДФ= 'MMMM yyyy'");
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;
		
		КонецЕсли;
		
	КонецЦикла;
	

	Если Источник.Количество() > 0 Тогда
		
		Если Источник[0].ПериодРегистрации <> ТекПериод Тогда
		
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя записывать данные другого периода. Текущий период " + Формат(ТекПериод,"ДФ= 'MMMM yyyy'");
			Сообщение.Сообщить();
			
			Отказ = Истина;
		
		КонецЕсли;
		
	
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗаполнениеНовогоДокументаОбработкаЗаполнения(Источник, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ДанныеЗаполнения = Неопределено Или ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Источник.ПериодРегистрации = Константы.ТекущийПериод.Получить();
	
	КонецЕсли;
	
	
КонецПроцедуры

