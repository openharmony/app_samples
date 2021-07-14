# AI<a name="EN-US_TOPIC_0000001080471882"></a>

-   HarmonyOSOpenHarmony provides abundant Artificial Intelligence \(AI\) capabilities that can be used out of the box. You can easily integrate these AI capabilities on demand to make your applications smarter. The AI capabilities are as follows:

    \* QR code generation: Generates a quick response \(QR\) code image based on a given string and QR code image size and returns it through byte streams. The caller can then restore the QR code image from the QR code byte streams.

    \* General text recognition: Converts scanned text on bills, cards, forms, newspapers, books, and other printed materials into image information, and then uses text recognition technologies to convert the image information into computable input.

    \* Single image super-resolution \(SISR\): Provides 1x and 3x super-resolution capabilities for mobile devices. 1x SR processing removes the image compression noise, and 3x SR processing enlarges the side edge by three times while suppressing the compression noise.

    \* Document skew detection and correction: Provides document skew detection and correction as an assisting enhancement in document duplicating.

    \* Text-image super-resolution \(TISR\): Enlarges an image containing text by nine times \(three times the height and three times the width\) and enhances the definition of text in the image.

    \* Word segmentation: Automatically segments input text into words at the specified granularity. You can change the granularity as required.

    \* POS tagging: Automatically segments input text into words and attaches a correct part of speech \(POS\) tag to each word. You can define your own POS tagging granularity as required.

    \* Assistant-specific intention recognition: Performs semantic analysis and intention recognition on text messages users send to devices, making devices smarter in various application scenarios.

    \* IM-specific intention recognition: Uses the machine learning technology to analyze and recognize intentions of text messages, such as short messages or messages from IM applications.

    \* Keyword extraction: Extracts the most relevant keywords from text. A keyword may be an entity with a specific meaning, such as a person name, a place, and a movie. It can also be a basic but critical word in the text.

    \* Entity recognition: Extracts entities with specific meanings from natural languages and performs related operations \(such as searching\) based on the extracted entities.

    \* Automatic speech recognition \(ASR\): Converts audio files and real-time audio data streams into Chinese character sequences at a recognition accuracy of over 90% \(95% for local recognition\).
