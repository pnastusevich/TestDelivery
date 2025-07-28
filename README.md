# 🍕 TestDelivery
**TestDelivery App** — это iOS-приложение, разработанное на **UIKit**, которое отображает меню еды с категориями и позициями. Приложение построено с акцентом на **чистую архитектуру**, модульность и **разделение ответственности** (Separation of Concerns), без использования сторонних библиотек.

---

## 📸 Скриншоты

<img width="1206" height="2622" alt="auth_screen" src="https://github.com/user-attachments/assets/2b7750c9-b045-4f64-a49a-a378ad89fc0e" />
<img width="1206" height="2622" alt="menu_screen" src="https://github.com/user-attachments/assets/7cecb049-c16e-4665-8df0-8b3be2e4f479" />

---

## ⚙️ Функциональность

- 📦 Загрузка меню из API (с категорией и блюдами)
- 🖼 Асинхронная загрузка изображений
- ♻️ Кэширование изображений через `NSCache`
- 🔁 Обновление UI при выборе категории
- 📐 Использование `UICollectionView` с секциями и кастомными хедерами
- ✅ Поддержка переиспользования ячеек без "прыгающих" картинок
- ❌ Без сторонних зависимостей — только `Foundation` и `UIKit`

---

## 🧩 Архитектура

Проект следует принципам **чистой архитектуры**:

- **NetworkManager** — отвечает за загрузку JSON-данных
- **ImageLoader** — фасад для загрузки и кэширования изображений
- **ImageNetworkManager** — загружает изображения из сети
- **ImageCacheManager** — кэширует изображения через `NSCache`
- **View + Presenter/Model** — обработка бизнес-логики отделена от UI


## 🔧 Установка и запуск

1. Склонируй репозиторий:

```bash
git clone https://github.com/your-username/testDelivery.git

2. Открой .xcodeproj в Xcode:
cd testDelivery
open TestDelivery.xcodeproj


## API

Приложение использует открытый API:
https://free-food-menus-api-two.vercel.app/all

Пример возвращаемого объекта:
[
  {
    "id": 1,
    "name": "Pepperoni Pizza",
    "dsc": "Hot pizza with extra cheese",
    "price": 499,
    "img": "https://example.com/pizza.jpg",
    "category": "pizza"
  }
]

