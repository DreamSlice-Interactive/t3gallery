# --- BUILD STAGE ---
# Verwende ein offizielles Node.js Image als Basis für den Build-Schritt
FROM node:20-alpine AS builder

# Installiere pnpm global im Container
# Dieser Befehl muss vor allen 'pnpm'-spezifischen Befehlen stehen
RUN npm install -g pnpm

RUN apk add --no-cache build-base python3 make g++

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die Paket-Definitionsdateien
COPY package.json ./
COPY pnpm-lock.yaml ./

# Installiere die Produktionsabhängigkeiten mit pnpm
RUN pnpm install --frozen-lockfile

# Kopiere den Rest des Anwendungscodes
COPY . .

# Führe den Next.js Build aus
# Wenn dein package.json Skript "build": "next build" ist und du pnpm nutzt.
# Wenn du den Build mit pnpm ausführen willst:
RUN pnpm build

# --- PRODUCTION STAGE ---
# Verwende ein sehr kleines und sicheres Node.js Image nur für die Laufzeit
FROM node:20-alpine

# WICHTIG: Hier musst du pnpm NICHT NOCHMAL installieren,
# wenn dein CMD Befehl npm verwendet. Wenn dein CMD aber pnpm verwendet,
# müsstest du pnpm auch hier installieren (was das Image größer macht).
# Da CMD ["npm", "run", "start"] gängig ist, lassen wir pnpm in dieser Stage weg.

# Setze das Arbeitsverzeichnis
WORKDIR /app
USER node

# Kopiere die generierten Next.js-Assets und die node_modules aus dem Build-Stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public

# Setze die Umgebungsvariablen für Next.js
ENV PORT 3000

# Exponiere den Port
EXPOSE 3000

# Definiere den Befehl zum Starten der Anwendung
# Dies nutzt das 'start'-Skript aus deiner package.json, welches normalerweise 'next start' ausführt.
# "npm" ist hier fast immer die richtige Wahl, da der 'start'-Befehl oft generisch ist
# und die Node.js Runtime auf npm basiert.
CMD ["npm", "run", "start"]